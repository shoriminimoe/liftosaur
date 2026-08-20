import "mocha";
import { expect } from "chai";
import { Settings_build } from "../src/models/settings";
import { OTA_DEFAULT_UPDATES_URL, Ota_areUpdatesEnabled, Ota_updatesUrl } from "../src/utils/otaUrl";

describe("Ota updates url", () => {
  it("falls back to the default url when unset", () => {
    const settings = Settings_build();
    expect(Ota_updatesUrl(settings)).to.equal(OTA_DEFAULT_UPDATES_URL);
    expect(Ota_areUpdatesEnabled(settings)).to.equal(true);
  });

  it("uses a custom url when set", () => {
    const settings = { ...Settings_build(), updatesUrl: "https://gym.example.com/api/updates/manifest" };
    expect(Ota_updatesUrl(settings)).to.equal("https://gym.example.com/api/updates/manifest");
    expect(Ota_areUpdatesEnabled(settings)).to.equal(true);
  });

  it("treats an empty url as disabled", () => {
    const settings = { ...Settings_build(), updatesUrl: "" };
    expect(Ota_updatesUrl(settings)).to.equal("");
    expect(Ota_areUpdatesEnabled(settings)).to.equal(false);
  });

  it("treats a whitespace-only url as disabled", () => {
    const settings = { ...Settings_build(), updatesUrl: "   " };
    expect(Ota_areUpdatesEnabled(settings)).to.equal(false);
  });
});
