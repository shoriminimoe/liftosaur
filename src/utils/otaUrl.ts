import { ISettings } from "../types";

export const OTA_DEFAULT_UPDATES_URL = "https://www.liftosaur.com/api/updates/manifest";

export function Ota_updatesUrl(settings: ISettings): string {
  return (settings.updatesUrl ?? OTA_DEFAULT_UPDATES_URL).trim();
}

export function Ota_areUpdatesEnabled(settings: ISettings): boolean {
  return Ota_updatesUrl(settings).length > 0;
}
