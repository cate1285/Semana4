defmodule ContadorControlador do
  @moduledoc """
  Módulo que implementa la comunicación entre un proceso contador y un proceso controlador.
  """

  @doc """
  Inicia el proceso de contador y controlador.
  """
  def start do
    # Inicia el proceso controlador
    controlador_pid = spawn(fn -> controlador() end)

    # Inicia el proceso contador y envía el primer valor al controlador
    spawn(fn -> contador(0, controlador_pid) end)
  end

  @doc false
  defp contador(valor, controlador_pid) do
    # Envía el valor actual del contador al controlador
    send(controlador_pid, {:contador, valor})

    # Espera un segundo antes de incrementar el contador
    :timer.sleep(1000)

    # Incrementa el contador y llama recursivamente a la función
    contador(valor + 1, controlador_pid)
  end

  @doc false
  defp controlador do
    receive do
      # Recibe un mensaje {:contador, valor} del proceso contador
      {:contador, valor} ->
        IO.puts("Valor del contador: #{valor}")

        # Continúa esperando más mensajes
        controlador()
    end
  end
end

# Inicia el programa ContadorControlador
ContadorControlador.start()
