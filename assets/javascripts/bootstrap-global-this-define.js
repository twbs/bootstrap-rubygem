// Set a `globalThis` so that bootstrap components are defined on window.bootstrap instead of window.
window['bootstrap'] = {
  Popper: window.Popper,
  _originalGlobalThis: window['globalThis']
};
window['globalThis'] = window['bootstrap'];
