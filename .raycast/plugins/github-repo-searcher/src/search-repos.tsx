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
  githubToken: string;
  organization: string;
}

interface Repository {
  id: number;
  name: string;
  full_name: string;
  description: string | null;
  html_url: string;
  language: string | null;
  stargazers_count: number;
  updated_at: string;
}

const CACHE_KEY = "github_org_repos";

export default function Command() {
  const [repos, setRepos] = useState<Repository[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const preferences = getPreferenceValues<Preferences>();

  useEffect(() => {
    loadRepos();
  }, []);

  async function loadRepos() {
    try {
      const cached = await LocalStorage.getItem<string>(CACHE_KEY);
      if (cached) {
        const data = JSON.parse(cached);
        setRepos(data);
      } else {
        await showToast({
          style: Toast.Style.Animated,
          title: "No cached repos",
          message: "Run 'Refresh Repository List' first",
        });
      }
    } catch (error) {
      await showToast({
        style: Toast.Style.Failure,
        title: "Failed to load repositories",
        message: String(error),
      });
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <List isLoading={isLoading} searchBarPlaceholder="Search repositories...">
      {repos.map((repo) => (
        <List.Item
          key={repo.id}
          title={repo.name}
          subtitle={repo.description || ""}
          accessories={[{ text: repo.language || "" }]}
          actions={
            <ActionPanel>
              <Action.OpenInBrowser url={repo.html_url} />
              <Action.CopyToClipboard
                title="Copy URL"
                content={repo.html_url}
                shortcut={{ modifiers: ["cmd"], key: "c" }}
              />
              <Action.CopyToClipboard
                title="Copy Clone Command"
                content={`git clone ${repo.html_url}.git`}
                shortcut={{ modifiers: ["cmd", "shift"], key: "c" }}
              />
            </ActionPanel>
          }
        />
      ))}
    </List>
  );
}
