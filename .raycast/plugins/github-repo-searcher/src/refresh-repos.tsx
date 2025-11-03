import {
  showToast,
  Toast,
  getPreferenceValues,
  LocalStorage,
  showHUD,
} from "@raycast/api";

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

export default async function Command() {
  const preferences = getPreferenceValues<Preferences>();

  await showToast({
    style: Toast.Style.Animated,
    title: "Fetching repositories...",
  });

  try {
    const repos: Repository[] = [];
    let page = 1;
    let hasMore = true;

    while (hasMore) {
      const response = await fetch(
        `https://api.github.com/orgs/${preferences.organization}/repos?per_page=100&page=${page}`,
        {
          headers: {
            Authorization: `Bearer ${preferences.githubToken}`,
            Accept: "application/vnd.github.v3+json",
          },
        },
      );

      if (!response.ok) {
        throw new Error(`GitHub API error: ${response.statusText}`);
      }

      const data = (await response.json()) as Repository[];

      if (data.length === 0) {
        hasMore = false;
      } else {
        repos.push(...data);
        page++;
      }
    }

    await LocalStorage.setItem(CACHE_KEY, JSON.stringify(repos));

    await showHUD(`✓ Fetched ${repos.length} repositories`);
  } catch (error) {
    await showToast({
      style: Toast.Style.Failure,
      title: "Failed to fetch repositories",
      message: String(error),
    });
  }
}
