/// <reference types="@raycast/api">

/* 🚧 🚧 🚧
 * This file is auto-generated from the extension's manifest.
 * Do not modify manually. Instead, update the `package.json` file.
 * 🚧 🚧 🚧 */

/* eslint-disable @typescript-eslint/ban-types */

type ExtensionPreferences = {
  /** TeamCity Token - TeamCity personal access token */
  "teamcityToken": string,
  /** TeamCity URL - TeamCity server URL (e.g., https://teampicnic.teamcity.com) */
  "teamcityUrl": string
}

/** Preferences accessible in all the extension's commands */
declare type Preferences = ExtensionPreferences

declare namespace Preferences {
  /** Preferences accessible in the `search-buildconfigs` command */
  export type SearchBuildconfigs = ExtensionPreferences & {}
  /** Preferences accessible in the `refresh-buildconfigs` command */
  export type RefreshBuildconfigs = ExtensionPreferences & {}
}

declare namespace Arguments {
  /** Arguments passed to the `search-buildconfigs` command */
  export type SearchBuildconfigs = {}
  /** Arguments passed to the `refresh-buildconfigs` command */
  export type RefreshBuildconfigs = {}
}

