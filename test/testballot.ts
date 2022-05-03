import "@nomiclabs/hardhat-ethers"
import {ethers} from "hardhat"
import {expect} from "chai"



describe("Ballot", async function(){
    const proposals=["0xd283f3979d00cb5493f2da07819695bc299fba34aa6e0bacb484fe07a2fc0ae0","0x4659db3b248cae1bb6856ee63308af6c9c15239e3bb76f425fbacdd84bb15330"]
    const testAddr='0xbda5747bfd65f08deb54cb465eb87d40e51b197e'
    async function createBallot() {
        const a=await ethers.getContractFactory("TestBallot")
        const A=await a.deploy(proposals)
        await A.deployed()
        return A
    }

    it('should intialize get the proposlas',async function(){
        const ballot=await createBallot()
        const proposals=await ballot.getProposals();
        expect(proposals).to.have.deep.members(proposals)
    })

    it('should give right to vote',async function(){
        const ballot=await createBallot()
        await ballot.giveRightToVote(testAddr);
        const current=await ballot.getWeight(testAddr)
        expect(current).to.equal(1)
    })

    it('should delegate a vote to another address',async function(){
        const ballot=await createBallot();
        await ballot.giveRightToVote(testAddr);
        const previous=await ballot.getWeight(testAddr)
        await ballot.delegate(testAddr);
        const current=await ballot.getWeight(testAddr)
        expect(current).to.equal(Number(previous)+1)
        
    })

    it('should vote and get winner',async function(){
        const ballot=await createBallot();
        const choice=0
        await ballot.vote(choice);
        const winner=await ballot.winnerName();
        expect(winner).to.equal(proposals[choice])
    })

    it('should fail at voting',async function(){
        let e:any
        try {
        const ballot=await createBallot();
        await ballot.setDate()
        await ballot.vote()
        } catch (error) {
            e=error
        }
    })

})