//SPDX-License-Identifier: MIT-License
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./CentroSalud.sol";

//contrato que maneja la OMS
contract OmsCovid{
    //VARIABLES
    //direccion de la OMS, dueña del contrato
    address public OMS;
    
    constructor() public{
        OMS = msg.sender;
    }

    //relaciona los centros de salud con la validez del sistema de gestion
    mapping(address => bool) public validacionCentrosSalud;

    //almacena los contratos de los centros de salud validados
    address[] public direccionesContratosSalud;

    //almacena las direcciones que soliciten acceso
    address[] solicitudes;

    //relaciona un centro salud con su contrato
    mapping(address => address) public centroSaludContrato;

    //EVENTOS
    //cuando hay un nuevo contrato
    event NuevoContrato(address, address);
    //cuando se valida un centro
    event NuevoCentroValidado(address);
    //cuando solicitan acceso al sistema
    event SolicitudAcceso(address);

    //MODIFICADORES
    modifier Unicamente(address _direccion){
        require(_direccion == OMS, "Solo la OMS puede ejecutar esta funcion");
        _;
    }

    //FUNCIONES
    //permite validar nuevos centros de salud para autogestionarse
    function CentrosSalud(address _centroSalud) public Unicamente(msg.sender){
        validacionCentrosSalud[_centroSalud] = true;
        emit NuevoCentroValidado(_centroSalud);
    }

    //permite crear un contrato inteligente para el centro de salud
    function FactoryCentroSalud() public {
        require(validacionCentrosSalud[msg.sender] == true, "El centro debe estar validado para ejecutar la funcion");
        address contratoCentroSalud = address(new CentroSalud(msg.sender));
        direccionesContratosSalud.push(contratoCentroSalud);
        centroSaludContrato[msg.sender] = contratoCentroSalud;
        
        emit NuevoContrato(contratoCentroSalud, msg.sender);
    }

    //permite solicitar acceso al sistema medico
    function SolicitarAcceso() public {
        solicitudes.push(msg.sender);
        emit SolicitudAcceso(msg.sender);
    }

    //permite visualizar a la oms las direcciones que solicitaron acceso
    function ViualizarSolicitudes() public view Unicamente(msg.sender) returns(address[] memory){
        return solicitudes;
    }
}