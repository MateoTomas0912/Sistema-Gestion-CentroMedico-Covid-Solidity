//SPDX-License-Identifier: MIT-License
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

//contrato que corresponde al centro de salud
contract CentroSalud {
    //VARIABLES
    //direccion del contrato correspondiente al centro
    address public direccionContrato;
    //direccion del centro de salud
    address direccionCentroSalud;

    constructor(address _direccion) public{
        direccionCentroSalud = _direccion;
        direccionContrato = address(this);
    }

    //relaciona el hash de la persona con los resultados
    mapping(bytes32 => Resultados) resultadosCovid;

    //estructura para guardar los resultados y el codigo ipfs
    struct Resultados{
        bool diagnostico;
        string codigoIpfs;
    }

    //EVENTOS
    //emite cuando se da un nuevo resultado de test
    event NuevoResultado(string, bool);

    //MODIFICADORES
    //verifica que solo el centro de salud ejecute la funcion
    modifier UnicamenteCentroSalud(address _direccion){
        require(_direccion == direccionCentroSalud, "No tienes permiso para ejecutar la funcion");
        _;
    }

    //FUNCIONES
    //permite emitir resultados de pruebas de covid
    function ResultadosPruebaCovid(string memory _idPersona, bool _resultado, string memory _codigoIPFS) public UnicamenteCentroSalud(msg.sender){
        bytes32 hashIdPersona = keccak256(abi.encodePacked(_idPersona));
        resultadosCovid[hashIdPersona] = Resultados(_resultado, _codigoIPFS);

        emit NuevoResultado(_codigoIPFS, _resultado);
    }

    //permite visualizar a los pacientes los resultados de la prueba 
    function VisualizarResultados(string memory _idPersona) public view returns(string memory, string memory){
        bytes32 hashIdPersona = keccak256(abi.encodePacked(_idPersona));
        string memory resultadosPrueba;

        if(resultadosCovid[hashIdPersona].diagnostico == true){
            resultadosPrueba = "Positivo";
        } else {
            resultadosPrueba = "Negativo";
        }

        return (resultadosPrueba, resultadosCovid[hashIdPersona].codigoIpfs);
    }
}