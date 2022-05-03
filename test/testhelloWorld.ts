import "@nomiclabs/hardhat-ethers"
import {ethers} from "hardhat"
import {expect} from "chai"


describe('HelloWorld',async function(){
    async function create() {
        const a=await ethers.getContractFactory("HelloWorld")
        const A=await a.deploy()
        await A.deployed()
        return A
    }

    it('should get 0',async function(){
        const helloWorld=await create()
        const num=await helloWorld.retrieveNumber();
        expect(num).to.equal(0)
    })

    it('should set value and get new value',async function(){
        const helloWorld=await create()
        const setNo=5
        await helloWorld.storeNumber(setNo)
        const num=await helloWorld.retrieveNumber();
        expect(num).to.equal(setNo)
    })
})