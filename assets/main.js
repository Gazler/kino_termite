import { Terminal } from "@xterm/xterm";
import { FitAddon } from '@xterm/addon-fit';
import "@xterm/xterm/css/xterm.css";


export function init(ctx, data) {
  ctx.importCSS("main.css")
  const term = new Terminal({cols: 80, rows: 24, convertEol: true});
  const fitAddon = new FitAddon();
  term.loadAddon(fitAddon);
  term.open(ctx.root);


  ctx.handleEvent("write", (contents) => {
    term.write(contents);
  });

  ctx.handleEvent("dimensions", () => {
    let height = term.rows;
    let width = term.cols;
    ctx.pushEvent("dimensions", {width: width, height: height});
  });

  new window.ResizeObserver(() => {
    fitAddon.fit();
  }).observe(ctx.root)

  term.onResize(({ cols, rows }) => ctx.pushEvent("resize"));
  term.onKey(({ key }) => ctx.pushEvent("key", { key }));
}
