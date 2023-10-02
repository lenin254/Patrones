# REPASO-PATRONES DE DISEÑO
## FFACTORY METHOD

## COMMAND

## BRIDGE

El patrón Bridge se utiliza para separar la abstracción de su implementación, permitiendo que ambas puedan variar de forma independiente.

En el código, se implementa el patrón Bridge con las siguientes clases clave:

- **`ControlRemotoBridge`**:
  - Es la abstracción en el patrón Bridge.
  - Se encarga de delegar las operaciones de encender y apagar al dispositivo subyacente (`@dispositivo`), ocultando la implementación real al cliente.

- **`Dipositivo`**, **`TV`**, **`Radio`**:
  - Estas son las implementaciones concretas.
  - `TV` y `Radio` heredan de `Dipositivo`.
  - `Dipositivo` define métodos `encender` y `apagar`, y estas implementaciones concretas definen cómo deben comportarse esos métodos para cada tipo de dispositivo.

- **`FabricaDispositivos`**, **`FabricaTV`**, **`FabricaRadio`**:
  - Aquí, `FabricaDispositivos` actúa como una abstracción que tiene un método `crear_dispositivos`.
  - `FabricaTV` y `FabricaRadio` son implementaciones concretas de la fábrica que heredan de `FabricaDispositivos`.
  - Cada fábrica concreta crea un tipo específico de dispositivo (`TV` o `Radio`) y lo devuelve.

El uso de estas clases siguiendo el patrón Bridge se refleja en la sección **"Uso del programa"**, donde se crea una instancia de `ControlRemotoBridge` para cada tipo de dispositivo (`tv_control` y `radio_control`). Esto permite que los comandos de encendido y apagado sean ejecutados para cada dispositivo sin necesidad de saber la implementación concreta del dispositivo en ese momento.

Así, el patrón Bridge desacopla la abstracción (control remoto) de la implementación concreta (dispositivos), lo que facilita la extensión y mantenimiento del sistema a medida que se agregan nuevos tipos de dispositivos sin afectar la abstracción y viceversa.  

A continuación se muestra las clases claves para la implementacion del patrón de nuestro codigo 

### Clase `ControlRemotoBridge` (Abstracción):

```ruby
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
```

### Clases `Dipositivo`, `TV`, y `Radio` (Implementación):

```ruby
class Dipositivo
  def encender
    raise NotImplementedError, "Subclasses deben implementar el método 'encender'"
  end

  def apagar
    raise NotImplementedError, "Subclasses deben implementar el método 'apagar'"
  end
end

class TV < Dipositivo
  def encender
    puts "Encendiendo el televisor"
  end

  def apagar
    puts "Apagando el televisor"
  end
end

class Radio < Dipositivo
  def encender
    puts "Encendiendo la radio"
  end

  def apagar
    puts "Apagando la radio"
  end
end
```

### Clases `FabricaDispositivos`, `FabricaTV`, y `FabricaRadio`:

```ruby
class FabricaDispositivos
  def crear_dispositivos
    raise NotImplementedError, "#{self.class} no ha implementado el metodo 'crear_dispositivos'"
  end
end

class FabricaTV < FabricaDispositivos
  def crear_dispositivos
    TV.new
  end
end

class FabricaRadio < FabricaDispositivos
  def crear_dispositivos
    Radio.new
  end
end
```

### Uso del Programa:

```ruby
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
```
