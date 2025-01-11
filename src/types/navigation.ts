export type RootStackParamList = {
  "(auth)/login": undefined;
  "(app)/home": undefined;
  "(app)/details/[id]": { id: string };
};

declare global {
  namespace ReactNavigation {
    interface RootParamList extends RootStackParamList { }
  }
}
