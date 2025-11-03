import {
  List,
  ActionPanel,
  Action,
  getPreferenceValues,
  LocalStorage,
  showToast,
  Toast,
} from "@raycast/api";
import { useEffect, useState } from "react";

interface Preferences {
  teamcityToken: string;
  teamcityUrl: string;
}

interface Project {
  id: string;
  name: string;
  parentProjectId?: string;
  webUrl: string;
}

const CACHE_KEY = "teamcity_projects";

export default function Command() {
  const [projects, setProjects] = useState<Project[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const preferences = getPreferenceValues<Preferences>();

  useEffect(() => {
    loadProjects();
  }, []);

  async function loadProjects() {
    try {
      const cached = await LocalStorage.getItem<string>(CACHE_KEY);
      if (cached) {
        const data = JSON.parse(cached);
        setProjects(data);
      } else {
        await showToast({
          style: Toast.Style.Animated,
          title: "No cached projects",
          message: "Run 'Refresh Project List' first",
        });
      }
    } catch (error) {
      await showToast({
        style: Toast.Style.Failure,
        title: "Failed to load projects",
        message: String(error),
      });
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <List isLoading={isLoading} searchBarPlaceholder="Search projects...">
      {projects.map((project) => {
        const isTeam =
          !project.parentProjectId || project.parentProjectId === "_Root";
        return (
          <List.Item
            key={project.id}
            title={project.name}
            accessories={[{ text: isTeam ? "Team" : "Project" }]}
            actions={
              <ActionPanel>
                <Action.OpenInBrowser url={project.webUrl} />
                <Action.CopyToClipboard
                  title="Copy URL"
                  content={project.webUrl}
                  shortcut={{ modifiers: ["cmd"], key: "c" }}
                />
                <Action.CopyToClipboard
                  title="Copy Project ID"
                  content={project.id}
                  shortcut={{ modifiers: ["cmd", "shift"], key: "c" }}
                />
              </ActionPanel>
            }
          />
        );
      })}
    </List>
  );
}
