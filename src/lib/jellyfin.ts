import { Jellyfin } from "@jellyfin/sdk";
import { deviceInfo, clientInfo } from "../config/client";

export const jellyfinClient = new Jellyfin({
  clientInfo,
  deviceInfo,
});
