# REPASO-PATRONES DE DISEÑO
## FACTORY METHOD

Muchas veces se comete el error de realizar proyectos cuyo enfoque en único, es decir solo están pensandos para un solo elemento y todas las funcionalidades están implementadas alrededor de dicho elemento único. A medida que nuestro proyecto escale se ve en la necesidad  de crear nuevos elementos por lo que es posible que tendremos que reestructurar todo el código. Para solucionar este problema se tiene el patrón Factory Method, este es un patrón de diseño creacional que tiene como disponibilida crear objetos en una superclase, mientras permite a las subclases alterar el tipo de objetos que se crearán. 

En el código, se implementa el patrón Factory Method para dar disponibilidad a la creación de dos elementos  **`TV`** y **`Radio`**.

### Clase `FabricaDispositivos`:

```ruby
class FabricaDispositivos
  def crear_dispositivos
    raise NotImplementedError, "#{self.class} no ha implementado el metodo '#{_method_}'"
  end
end
```

Esta es la clase base del patrón Factory Method que actúa como el método de fábrica. Se ve que no se ha creado ningún tipo de objeto específico, es en las subclases de esta clase base que deben implementar este método para crear dichos objetos. También se implementa un mensaje de excepcion en `NotImplementedError, "#{self.class} no ha implementado el metodo '#{_method_}'"` esto ayuda a identificar la clase y el método que aún deben implementarse. 


### Clase `FabricaTV` y `FabricaRadio`:

```ruby
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

Estas dos clases heredan el método de la superclase `FabricaDispositivos`, cada una de las subclases implementan de manera concreta la creación de dos nuevos dispositivos, para este caso particular la clase `FabricaTV` implementa una `TV` y la clase `FabricaRadio` implementa una `Radio`.

Esta es una de las formas en la que se pueden implementar nuevos elementos de modo que el resto del código o programa no se vea comprometido, ya que es independiente del tipo de elemento a procesar. Por lo que este método nos permite implementar independencia de abstracción y por lo que se puede realizar nuevas implementaciones.

## COMMAND
Este patrón de diseño consiste de 4 elementos: Una **interfaz de comandos**, una **clase receptora**, una **clase invocadora** y **Comandos** que implementen la interfaz de comandos.  
 
El objeto **comando** no contiene la lógica de la tarea (método) a realizarse, la que se encargará de esto es el objeto **receptor**. El objeto comando lo que contiene son los parámetros necesarios para la ejecución de la tarea, así como una referencia al objeto receptor en sí. El objeto receptor realizará la tarea cuando se invoque el método *execute()* del objeto comando.

El objeto **invocador** tiene la tarea de invocar el método *execute()* de un objeto comando a través de la **interfaz de comandos**. Para esto se debe pasar al objeto **invocador** qué comando se desea ejecutar. 

La idea principal de este patrón de diseño es en lugar de pasar una solicitud directamente a un objeto receptor, podamos encapsular esta solicitud en un objeto autónomo **comando**. Esto no solo nos ayuda a desacoplar la lógica del invocador del comando en sí, sino que el convertir esa solicitud en un objeto nos abre más posibilidades: podemos agregarlos a una lista y crear un historial de comandos, podemos formar un sistema de colar, etc.

```ruby
class ComandoDispositivo
  def execute
    raise NotImplementedError, "Subclasses deben implementar el método 'execute'"
  end
end

class ComandoEncender < ComandoDispositivo
  def initialize(dispositivo)
    @dispositivo = dispositivo
  end

  def execute
    @dispositivo.encender
  end
end

class ComandoApagar < ComandoDispositivo
  def initialize(dispositivo)
    @dispositivo = dispositivo
  end

  def execute 
    @dispositivo.apagar
  end
end
```
En este caso, **ComandoDispositivo** es la interface que implementaran los comandos concretos **ComandoEncender** y **ComandoApagar**. Estos dos comandos llaman a los métodos **encender** y **apagar** del objeto cuya referencia se les ha pasado. Las clases receptoras serian las clases que definimos anteriormente:

```ruby
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

```
Y finalmente, definimos una clase invocadora **ControlRemotoCommand** que se encargará de la ejecución de los comandos que le pasemos.

```ruby
class ControlRemotoCommand
  def setComando(comando)
    @comando = comando
  end

  def executeComando
    @comando.execute if @comando.is_a? ComandoDispositivo
  end
end
```
A continuación observamos como inicializar un objeto ControlRemotoCommand y como debemos pasarle los comandos a realizar:
```ruby
control = ControlRemotoCommand.new

control.setComando(ComandoEncender.new(tv))
control.executeComando
```
Al objeto invocador **control** le pasamos como argumento el nuevo objeto comando **ComandoEncender.new(tv)** que se encargará de llamar al método **encender** del objeto **tv**. En la siguiente línea le indicamos a **control** que ejecute el comando que tenga guardado.

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
