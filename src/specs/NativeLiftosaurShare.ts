import type { TurboModule } from "react-native";
import { TurboModuleRegistry } from "react-native";

// eslint-disable-next-line @typescript-eslint/naming-convention
export interface Spec extends TurboModule {
  shareLog(): Promise<void>;
}

export default TurboModuleRegistry.getEnforcing<Spec>("LiftosaurShare");
