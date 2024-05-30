// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.19;

import {Test,console} from "lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {Test, console} from "lib/forge-std/src/Test.sol";
import {StdCheats} from "lib/forge-std/src/StdCheats.sol";

contract FundMeTest  is Test {

    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external{
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306); //FundMe variable of type fundMe will be a new FundMe Contract
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    } //SETUP FUNCTION ALWAYS BE THE FIRST ONE TO BE READ
    
    function testMinimumDollar() public{
        assertEq(fundMe.MINIMUM_USD(), 5e18); //CHECK IF MINIMUM USD IN THE CONTRACT IS 5e18
    } //THEN ONLY TESTDEMO

    function testIfOwnerisMessageSender() public { //Function name must have prefix "test"
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testIfPriceFeedAccurate() public {
       uint256 a = fundMe.getVersion();
       assertEq(a,4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();//hey this next line should revert
        fundMe.fund(); //send 0 value
    }
    
    function testFundUpdatesFundedDataStructure() public {
        vm.startPrank(USER); //the next TX will be sent by USER
        fundMe.fund{value:SEND_VALUE}();
        vm.stopPrank();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFundersToArrayOfFunders() public {
        vm.startPrank(USER);
        fundMe.fund{value:SEND_VALUE}();

        address funder = fundMe.getFunder(0);
        assertEq(funder,USER);
    }


    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value:SEND_VALUE}();
        _;
    }
    function testOnlyOwnerCanWithdraw() public funded{
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithDrawWithSingleFunder() public funded {
        //ARRANGE
        uint256 StartingOwnerBalance = fundMe.getOwner().balance;
        uint256 StartingFundMeBalance = address(fundMe).balance;


        //ACT
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();


        //ASSERT
        uint256 EndingOwnerBalance = fundMe.getOwner().balance;
        uint256 EndingFundMeBalance = address(fundMe).balance;

        assertEq(EndingFundMeBalance,0);
        assertEq(
            StartingFundMeBalance + StartingOwnerBalance, 
            EndingOwnerBalance
        );

    }

    function testWithDrawFromMultipleFunders() public funded {
        //Arrange
        uint160 numberOfFunders=10;
        uint160 startingFunderIndex =2;
        //loop
        for(uint160 i =startingFunderIndex; i<numberOfFunders; i++){
            //vm.prank new address
            //vm.deal new address
            //prank and deal can be combined using hoax()
            hoax(address(i),SEND_VALUE);
            fundMe.fund{value:SEND_VALUE}();
        }

        uint256 StartingOwnerBalance = fundMe.getOwner().balance;
        uint256 StartingFundMeBalance = address(fundMe).balance;

        //Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw(); //should've pay gas
        vm.stopPrank();
        //3 line above means anything between start and stop prank, are done by the address in startprank (getOwner)

        //Assert
        assert(address(fundMe).balance ==0);
        assert(
            StartingFundMeBalance + StartingOwnerBalance == fundMe.getOwner().balance
            );
    }

    function testWithDrawFromMultipleFundersCheaper() public funded {
        //Arrange
        uint160 numberOfFunders=10;
        uint160 startingFunderIndex =2;
        //loop
        for(uint160 i =startingFunderIndex; i<numberOfFunders; i++){
            //vm.prank new address
            //vm.deal new address
            //prank and deal can be combined using hoax()
            hoax(address(i),SEND_VALUE);
            fundMe.fund{value:SEND_VALUE}();
        }

        uint256 StartingOwnerBalance = fundMe.getOwner().balance;
        uint256 StartingFundMeBalance = address(fundMe).balance;

        //Act
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw(); //should've pay gas
        vm.stopPrank();
        //3 line above means anything between start and stop prank, are done by the address in startprank (getOwner)

        //Assert
        assert(address(fundMe).balance ==0);
        assert(
            StartingFundMeBalance + StartingOwnerBalance == fundMe.getOwner().balance
            );
    }
}

