pragma solidity >=0.7.0 <0.8.0; 


library CryptoSuite {
    function splitSignature(bytes memory sig) internal pure returns(uint8 v, bytes32 r, bytes32 s) {
        require(sig.length == 65);

        assembly {
            // first 32 bytes
            r := mload(add(sig, 32))

            // next 32 bytes
            s := mload(add(sig, 64))

            // last 32 bytes
            v := byte(0, mload(add(sig, 96)))
        }
        return (v, r, s);
    }
    function recoverSigner(bytes32 message, bytes memory sig) internal pure returns(address) {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);

        return ecrecover(message, v, r, s);
    }

}


contract ColdChain {
    enum Mode { ISSUER, PROVER, VERIFIER }

    struct Entity {
        address id;
        Mode mode;
        uint[] certificateIds;
    }

    enum CertificateStatus {MANUFACTURED, DELIVERING_INTERNATIONAL, STORED, DELIVERING_LOCAL, DELIVERED}

    struct Certificate {
        uint id;
        Entity issuer;
        Entity prover;
        bytes signature;
        Status status;
    }

    struct VaccineBatch {
        uint id;
        string brand;
        address manufacturer;
        uint[] certificateIds;
    }

    uint public constant MAX_CERTIFICATIONS = 2;

    uint[] public certificateIds;
    uint[] public vaccineBatchIds;

    mapping(uint => VaccineBatchIds) public vaccineBatches;
    mapping(uint => CertificateIds) public certificates;
    mapping(address => Entity) public entities;

    event AddEntity(address entityId, string entityMode);
    event AddVaccineBatch(uint vaccineBatchId, address indexed manufacturer);
    event IssueCertificate(address indexed issuer, address indexed prover, uint certificateId);

    function AddEntity(address _id, string memory _mode) public {
        Mode mode = unmarshalMode(_mode);
        uint[] memory _certificateId = new uint[](MAX_CERTIFICATIONS);
        Entity memory entity = Entity(_id, mode, _certificateIds);
        entities[_id] = entity;

        emit AddEntity(entity.id, _mode)
    }

    function unmarshalMode(string memory _mode) private pure returns(Mode mode){
        bytes32 encodedMode = keccak256(abi.encodePacked(_mode));
        bytes32 encodedMode0 = keccak256(abi.encodePacked("ISSUER"));
        bytes32 encodedMode1 = keccak256(abi.encodePacked("PROVER"));
        bytes32 encodedMode2 = keccak256(abi.encodePacked("VERIFIER"));

        if(encodedMode == encodedMode0){
            return Mode.ISSUER;
        }
        else if (encodedMode == encodedMode1){
            return Mode.PROVER;
        }
        else if (encodedMode == encodedMode2){
            return Mode.VERIFIER;
        }

        revert("receive an invalid entity mode")

    }

    function AddVaccineBatch(string memory brand, address manufacturer) public {
        Mode mode = unmarshalMode(brand);
        uint[] memory _certificateId = new uint[](MAX_CERTIFICATIONS);
        Entity memory entity = Entity(_id, mode, _certificateIds);
        entities[_id] = entity;

        emit AddEntity(entity.id, brand)
    }

    function unmarshalMode(string memory brand) private pure returns(Mode mode){
        bytes32 encodedMode = keccak256(abi.encodePacked(brand));
        bytes32 encodedMode0 = keccak256(abi.encodePacked("ISSUER"));
        bytes32 encodedMode1 = keccak256(abi.encodePacked("PROVER"));
        bytes32 encodedMode2 = keccak256(abi.encodePacked("VERIFIER"));

        if(encodedMode == encodedMode0){
            return Mode.ISSUER;
        }
        else if (encodedMode == encodedMode1){
            return Mode.PROVER;
        }
        else if (encodedMode == encodedMode2){
            return Mode.VERIFIER;
        }

        revert("receive an invalid entity mode")

    }
}