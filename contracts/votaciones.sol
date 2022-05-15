// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;


contract votaciones {

    address public owner;

    constructor()public{
        owner = msg.sender;
    }

    //realcion candidato y datos
    mapping(string => bytes32) id_candidato;

    mapping(string => bool) public candidatosEsten;

    //relacion candidato y votos
    mapping(string=> uint256) votos_candidato;

    //lista de candidatos
    string [] candidatos;

    //lista de votantes;
    bytes32 [] votantes;

    //listar candidato
    function Representantes(string memory _nombre , uint256 _edad , string memory _id ) public{
       //que el candidato ya no se alla postulado 
       require (!candidatosEsten[_nombre], "ya esta este candidato");
       
        //hash candidatos
        bytes32 hash_candidato = keccak256(abi.encodePacked(_nombre, _edad, _id));

        id_candidato[_nombre] = hash_candidato;
    
        candidatosEsten[_nombre] = true;

        candidatos.push(_nombre);

    }


    //ver candidatos
    function verCandidatos() public view returns(string [] memory) {
        return candidatos;
    }


    //votar candidato
    function votarCandidaato(string memory _candidato) public {
        //hash del votante
        bytes32 hash_votante = keccak256(abi.encodePacked(msg.sender));
        //verifacar si ya voto
        for(uint i = 0; i< votantes.length; i++){
            require(votantes[i] != hash_votante, "ya votastesss");
        }
        //agregarlo si no voto
        votantes.push(hash_votante);

        //añadimos al candidato  
        votos_candidato[_candidato]++;

    }



    //cantidad de votos
    function verCantidadVotos(string memory _candidato) public view returns(uint256){
        return votos_candidato[_candidato];
    }


    //Funcion auxiliar que transforma un uint a un string

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }


    //resultados
    function verResultados() public view returns(string memory ) {
        //guardamos los candidatos
        string memory resultados;

        for(uint i = 0; i< candidatos.length; i++){
           resultados =string (abi.encodePacked(resultados,"(", candidatos[i], ",", uint2str(verCantidadVotos(candidatos[i])), ")"));
        }
        return resultados ;

    } 


    //ganador
    function ganador() public view returns(string memory) {
        string memory ganador = candidatos[0];
        bool flag ;

        for(uint i = 1; i< candidatos.length; i++){
            if(votos_candidato[ganador] < votos_candidato[candidatos[i]]){
                ganador = candidatos[i];
                flag = false;
            }else{
                if(votos_candidato[ganador] == votos_candidato[candidatos[i]]){
                    flag = true;
                }
            }
        }

        if(flag == true){
            ganador = "hay un empateeeeeee";
        }

        return ganador ;
    }
}