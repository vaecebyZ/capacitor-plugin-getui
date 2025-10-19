export interface GetuiPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
