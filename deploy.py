import solcx

solcx.install_solc("v0.8.0")

from web3 import Web3
from solcx import compile_source, install_solc

# Ensure solc is installed
# install_solc("0.8.0")

w3 = Web3(Web3.HTTPProvider('http://127.0.0.1:7545'))

def compile_contract():
    with open('./ToDoList.sol', 'r') as file:
        contract_source_code = file.read()

    compiled_sol = compile_source(contract_source_code, solc_version="0.8.0")
    contract_interface = compiled_sol['<stdin>:ToDoList']

    return contract_interface['abi'], contract_interface['bin']

def deploy_contract():
    account = w3.eth.accounts[0]
    abi, bytecode = compile_contract()

    contract = w3.eth.contract(abi=abi, bytecode=bytecode)
    transaction_hash = contract.constructor().transact({'from': account})
    transaction_receipt = w3.eth.wait_for_transaction_receipt(transaction_hash)

    contract_address = transaction_receipt['contractAddress']
    return contract_address, abi

if __name__ == "__main__":
    contract_address, abi  = deploy_contract()
    print(f"Contract Address: {contract_address}")
    print(f"ABI: {abi}")
    # print(bc)
