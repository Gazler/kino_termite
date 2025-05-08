# KinoTermite

Termite adapter for LiveBook

## Installation

KinoTermite provides xtermjs support for Termite so that it can be used inside
of LiveBook.

To use it, create a cell with the following:

```elixir
terminal = Termite.Terminal.start(adapter: KinoTermite.Adapter)
KinoTermite.output(terminal)
```

This will output the terminal.

In a separate code cell, code can be sent to the terminal:

```elixir
Termite.Screen.write(terminal, "This is a simple demo. Press q to exit.\n")
  loop = fn fun ->
    case Termite.Terminal.poll(terminal, 100) do
      {:data, "q"} -> Termite.Screen.write(terminal, "finished")
    :timeout -> Termite.Screen.write(terminal, "."); fun.(fun)
  _ -> fun.(fun)
  end
end

loop.(loop)
```
