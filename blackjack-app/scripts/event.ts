//@ts-nocheck

export async function onEvent(
  eventName,
  {
    onEventConnected = () => {},
    onEventReceived,
    onEventRemoved = () => {},
    onError = () => {},
  },
  contract,
  options
) {
  const listeners = contract.events[eventName](options)
    .on("connected", onEventConnected)
    .on("changed", onEventRemoved)
    .on("data", onEventReceived)
    .on("error", onError);

  await listeners;
  return () => {
    listeners
      .off("connected", onEventConnected)
      .off("changed", onEventRemoved)
      .off("data", onEventReceived)
      .off("error", onError);
  };
}
