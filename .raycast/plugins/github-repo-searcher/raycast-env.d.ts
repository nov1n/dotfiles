/// <reference types="@raycast/api">

/* 🚧 🚧 🚧
 * This file is auto-generated from the extension's manifest.
 * Do not modify manually. Instead, update the `package.json` file.
 * 🚧 🚧 🚧 */

/* eslint-disable @typescript-eslint/ban-types */

type ExtensionPreferences = {
  /** GitHub Token - Personal access token with repo scope */
  "githubToken": string,
  /** Organization - GitHub organization name */
  "organization": string
}

/** Preferences accessible in all the extension's commands */
declare type Preferences = ExtensionPreferences

declare namespace Preferences {
  /** Preferences accessible in the `search-repos` command */
  export type SearchRepos = ExtensionPreferences & {}
  /** Preferences accessible in the `refresh-repos` command */
  export type RefreshRepos = ExtensionPreferences & {}
}

declare namespace Arguments {
  /** Arguments passed to the `search-repos` command */
  export type SearchRepos = {}
  /** Arguments passed to the `refresh-repos` command */
  export type RefreshRepos = {}
}

