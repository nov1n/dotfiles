import {
  showToast,
  Toast,
  getPreferenceValues,
  LocalStorage,
  showHUD,
} from "@raycast/api";

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

interface TeamCityProject {
  id: string;
  name: string;
  parentProjectId?: string;
  webUrl: string;
}

interface TeamCityProjectsResponse {
  project: TeamCityProject[];
}

const CACHE_KEY = "teamcity_projects";

export default async function Command() {
  const preferences = getPreferenceValues<Preferences>();

  await showToast({
    style: Toast.Style.Animated,
    title: "Fetching projects...",
  });

  try {
    const url = `${preferences.teamcityUrl}/app/rest/projects`;

    const response = await fetch(url, {
      headers: {
        Authorization: `Bearer ${preferences.teamcityToken}`,
        Accept: "application/json",
      },
    });

    if (!response.ok) {
      throw new Error(`TeamCity API error: ${response.statusText}`);
    }

    const data = (await response.json()) as TeamCityProjectsResponse;

    const projects: Project[] = data.project.map((p) => ({
      id: p.id,
      name: p.name,
      parentProjectId: p.parentProjectId,
      webUrl: p.webUrl,
    }));

    await LocalStorage.setItem(CACHE_KEY, JSON.stringify(projects));

    await showHUD(`✓ Fetched ${projects.length} projects`);
  } catch (error) {
    await showToast({
      style: Toast.Style.Failure,
      title: "Failed to fetch projects",
      message: String(error),
    });
  }
}
