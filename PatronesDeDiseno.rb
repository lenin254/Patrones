# frozen_string_literal: true
# Patrón Factory Method

# Clase Factory
class FabricaDispositivos
  def crear_dispositivos
    raise NotImplementedError, "#{self.class} no ha implementado el metodo '#{_method_}'"
  end
end

# Clase Factory - TV
class FabricaTV < FabricaDispositivos
  def crear_dispositivos
    TV.new
  end
end

# Clase Factory - Radio
class FabricaRadio < FabricaDispositivos
  def crear_dispositivos
    Radio.new
  end
end

# Clase Product
class Dipositivo
  def encender
    raise NotImplementedError, "Subclasses deben implementar el método 'encender'"
  end

  def apagar
    raise NotImplementedError, "Subclasses deben implementar el método 'apagar'"
  end
end

# Clase Product - TV
class TV < Dipositivo
  def encender
    puts "Encendiendo el televisor"
  end

  def apagar
    puts "Apagando el televisor"
  end
end

# Clase Product - Radio
class Radio < Dipositivo
  def encender
    puts "Encendiendo la radio"
  end

  def apagar
    puts "Apagando la radio"
  end
end

# Patrón Command
class ComandoDispositivo
  def initialize(dispositivo)
    @dispositivo = dispositivo
  end

  def execute
    raise NotImplementedError, "Subclasses deben implementar el método 'execute'"
  end
end

class ComandoEncender < ComandoDispositivo
  def execute
    @dispositivo.encender
  end
end

class ComandoApagar < ComandoDispositivo
  def execute
    @dispositivo.apagar
  end
end

class ControlRemotoCommand
  def setComando(comando)
    @comando = comando
  end

  def executeComando
    @comando.execute if @comando.is_a? ComandoDispositivo
  end
end

# Patrón Bridge
class ControlRemotoBridge
  def initialize(dispositivo)
    @dispositivo = dispositivo
  end

  def encender
    @dispositivo.encender
  end

  def apagar
    @dispositivo.apagar
  end
end






# Uso del programa
########################

fabrica_tv = FabricaTV.new
tv = fabrica_tv.crear_dispositivos

fabrica_radio = FabricaRadio.new
radio = fabrica_radio.crear_dispositivos

tv_control = ControlRemotoBridge.new(tv)
radio_control = ControlRemotoBridge.new(radio)

tv_control.encender
tv_control.apagar
radio_control.encender
radio_control.apagar

#########################
control = ControlRemotoCommand.new

control.setComando(ComandoEncender.new(tv))
control.executeComando
control.setComando(ComandoApagar.new(tv))
control.executeComando
control.setComando(ComandoEncender.new(radio))
control.executeComando
control.setComando(ComandoApagar.new(radio))
control.executeComando