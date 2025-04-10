defmodule KinoTermite do
  @moduledoc """
  KinoTermite provides xtermjs support for Termite so that it can be used inside
  of LiveBook.

  To use it, create a cell with the following:

  ```elixir
  terminal = Termite.Terminal.start(adapter: KinoTermite.Adapter)
  KinoTermite.output(terminal)
  ```

  This will output the terminal.

  In a separate code cell, code can be sent to the terminal

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
  """

  use Kino.JS, assets_path: "lib/assets/xterm/build"
  use Kino.JS.Live

  def new(opts) do
    Kino.JS.Live.new(__MODULE__, opts)
  end

  @doc """
  Output the Kino cell. This should be used in LiveBook to output the terminal
  """
  def output(%{adapter: {KinoTermite.Adapter, term}}) do
    term.kino
  end

  def dimensions(kino) do
    Kino.JS.Live.call(kino, :dimensions)
  end

  def write(kino, str) do
    Kino.JS.Live.cast(kino, {:write, str})
  end

  @impl true
  def init(opts, ctx) do
    pid = Keyword.fetch!(opts, :pid)
    {:ok, assign(ctx, pid: pid, from: nil, resize: nil)}
  end

  @impl true
  def handle_connect(ctx) do
    {:ok, "", ctx}
  end

  @impl true
  def handle_cast({:write, str}, ctx) do
    broadcast_event(ctx, "write", str)
    {:noreply, ctx}
  end

  @impl true
  def handle_call(:dimensions, from, ctx) do
    broadcast_event(ctx, "dimensions", %{})
    {:noreply, assign(ctx, from: from)}
  end

  @impl true
  def handle_event("key", %{"key" => key}, ctx) do
    send(ctx.assigns.pid, {:reader, {:data, key}})
    {:noreply, ctx}
  end

  def handle_event("resize", _, ctx) do
    send(ctx.assigns.pid, {:reader, {:signal, :winch}})
    {:noreply, assign(ctx, resize: true)}
  end

  def handle_event("dimensions", %{"width" => width, "height" => height}, ctx) do
    GenServer.reply(ctx.assigns.from, %{width: width, height: height})
    {:noreply, assign(ctx, from: nil)}
  end
end
