defmodule KinoTermite.Adapter do
  @behaviour Termite.Terminal.Adapter

  @impl true
  def reader(term) do
    {:ok, term.reader}
  end

  @impl true
  def resize(term) do
    if term.state != :initial do
      GenServer.call(term.kino.pid, :dimensions)
    else
      %{width: 80, height: 24}
    end
  end

  @doc false
  @impl true
  def start(_opts \\ []) do
    kino = KinoTermite.new(pid: self())
    term = %{kino: kino, state: :initial, reader: :reader}
    {:ok, term}
  end

  @doc false
  @impl true
  def write(term, str) do
    KinoTermite.write(term.kino, str)
    {:ok, %{term | state: :created}}
  end
end
