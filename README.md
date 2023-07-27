# Smart Contracts para el Centro Médico en Etapa de Pandemia

Este proyecto utiliza la tecnología blockchain y smart contracts para permitir que un centro médico emita y gestione los resultados de las pruebas PCR de sus clientes de manera segura y transparente. Los smart contracts están escritos en Solidity, un lenguaje de programación para contratos inteligentes en la red Ethereum.
El proyecto fue realizado en el marco del curso SmartContracts y Blockchain con Solidity de la A a la Z
A continuación, se detalla el funcionamiento de cada uno de los contratos:

## 1. CentroSalud.sol

Este contrato corresponde al centro médico que realiza las pruebas de COVID-19 y emite los resultados a través de la blockchain.

### Variables

- `direccionContrato`: La dirección del contrato correspondiente al centro de salud (dirección del contrato actual).
- `direccionCentroSalud`: La dirección del centro de salud que posee este contrato.

### Estructura

- `Resultados`: Una estructura que contiene dos atributos:
  - `diagnostico`: Un valor booleano que indica si el resultado de la prueba es positivo (true) o negativo (false).
  - `codigoIpfs`: Una cadena de texto que almacena el código IPFS relacionado con el resultado de la prueba.

### Eventos

- `NuevoResultado`: Se emite cuando se agrega un nuevo resultado de prueba al contrato. Contiene el código IPFS y el resultado de la prueba.

### Modificadores

- `UnicamenteCentroSalud`: Verifica que solo el centro de salud ejecuta la función.

### Funciones

- `constructor`: El constructor del contrato que se ejecuta al desplegarlo en la red. Recibe como parámetro la dirección del centro de salud que posee el contrato y establece las direcciones correspondientes.

- `ResultadosPruebaCovid`: Permite al centro de salud emitir resultados de pruebas de COVID-19. Solo puede ser ejecutada por el centro de salud y recibe como parámetros el ID de la persona, el resultado de la prueba y el código IPFS relacionado con el resultado. El resultado y el código IPFS se almacenan en la estructura `Resultados`, asociados al hash del ID de la persona. Se emite el evento `NuevoResultado`.

- `VisualizarResultados`: Permite a los pacientes visualizar los resultados de sus pruebas de COVID-19. Se accede a través del ID de la persona y devuelve el resultado ("Positivo" o "Negativo") y el código IPFS asociado al resultado.

## 2. OmsCovid.sol

Este contrato maneja la organización mundial de la salud (OMS) y su interacción con los centros de salud.

### Variables

- `OMS`: La dirección de la OMS, que es la propietaria del contrato.

### Funciones

- `constructor`: El constructor del contrato que se ejecuta al desplegarlo en la red. Establece que la dirección de la OMS es la que despliega el contrato.

- `CentrosSalud`: Permite a la OMS validar nuevos centros de salud para que puedan autogestionarse. Solo puede ser ejecutada por la OMS y recibe como parámetro la dirección del centro de salud que se valida.

- `FactoryCentroSalud`: Permite a un centro de salud validado crear un contrato inteligente (`CentroSalud.sol`) para gestionar los resultados de las pruebas de COVID-19. Se verifica que el centro de salud esté validado y, luego, se despliega un nuevo contrato `CentroSalud.sol` para el centro de salud. La dirección del contrato se almacena en el mapeo `centroSaludContrato` asociado a la dirección del centro de salud.

- `SolicitarAcceso`: Permite a los centros de salud solicitar acceso al sistema médico de la OMS. La dirección del centro de salud que solicita acceso se guarda en el arreglo `solicitudes`.

- `ViualizarSolicitudes`: Permite a la OMS visualizar las direcciones de los centros de salud que han solicitado acceso al sistema médico. Esta función solo puede ser ejecutada por la OMS y devuelve un arreglo con las direcciones de las solicitudes.

Espero que esta información sea útil para entender el funcionamiento de los smart contracts y cómo permiten la gestión de resultados de pruebas PCR a través de la blockchain para el centro médico en etapa de pandemia. Recuerda que este código está escrito en Solidity y está diseñado para la red Ethereum o una red compatible con EVM (Ethereum Virtual Machine).
