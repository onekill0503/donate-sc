import { newMockEvent } from "matchstick-as"
import { ethereum, Address, BigInt } from "@graphprotocol/graph-ts"
import {
  ClaimReward,
  InitiateWithdraw,
  NewDonation,
  OwnershipTransferred,
  addAllowedDonationTokenEvent,
  removeAllowedDonationTokenEvent
} from "../generated/Donate/Donate"

export function createClaimRewardEvent(
  user: Address,
  amount: BigInt,
  timestamp: BigInt
): ClaimReward {
  let claimRewardEvent = changetype<ClaimReward>(newMockEvent())

  claimRewardEvent.parameters = new Array()

  claimRewardEvent.parameters.push(
    new ethereum.EventParam("user", ethereum.Value.fromAddress(user))
  )
  claimRewardEvent.parameters.push(
    new ethereum.EventParam("amount", ethereum.Value.fromUnsignedBigInt(amount))
  )
  claimRewardEvent.parameters.push(
    new ethereum.EventParam(
      "timestamp",
      ethereum.Value.fromUnsignedBigInt(timestamp)
    )
  )

  return claimRewardEvent
}

export function createInitiateWithdrawEvent(
  creator: Address,
  shares: BigInt,
  timestamp: BigInt
): InitiateWithdraw {
  let initiateWithdrawEvent = changetype<InitiateWithdraw>(newMockEvent())

  initiateWithdrawEvent.parameters = new Array()

  initiateWithdrawEvent.parameters.push(
    new ethereum.EventParam("creator", ethereum.Value.fromAddress(creator))
  )
  initiateWithdrawEvent.parameters.push(
    new ethereum.EventParam("shares", ethereum.Value.fromUnsignedBigInt(shares))
  )
  initiateWithdrawEvent.parameters.push(
    new ethereum.EventParam(
      "timestamp",
      ethereum.Value.fromUnsignedBigInt(timestamp)
    )
  )

  return initiateWithdrawEvent
}

export function createNewDonationEvent(
  gifter: Address,
  grossAmount: BigInt,
  netAmount: BigInt,
  creator: Address,
  gifterShares: BigInt,
  timestamp: BigInt
): NewDonation {
  let newDonationEvent = changetype<NewDonation>(newMockEvent())

  newDonationEvent.parameters = new Array()

  newDonationEvent.parameters.push(
    new ethereum.EventParam("gifter", ethereum.Value.fromAddress(gifter))
  )
  newDonationEvent.parameters.push(
    new ethereum.EventParam(
      "grossAmount",
      ethereum.Value.fromUnsignedBigInt(grossAmount)
    )
  )
  newDonationEvent.parameters.push(
    new ethereum.EventParam(
      "netAmount",
      ethereum.Value.fromUnsignedBigInt(netAmount)
    )
  )
  newDonationEvent.parameters.push(
    new ethereum.EventParam("creator", ethereum.Value.fromAddress(creator))
  )
  newDonationEvent.parameters.push(
    new ethereum.EventParam(
      "gifterShares",
      ethereum.Value.fromUnsignedBigInt(gifterShares)
    )
  )
  newDonationEvent.parameters.push(
    new ethereum.EventParam(
      "timestamp",
      ethereum.Value.fromUnsignedBigInt(timestamp)
    )
  )

  return newDonationEvent
}

export function createOwnershipTransferredEvent(
  previousOwner: Address,
  newOwner: Address
): OwnershipTransferred {
  let ownershipTransferredEvent = changetype<OwnershipTransferred>(
    newMockEvent()
  )

  ownershipTransferredEvent.parameters = new Array()

  ownershipTransferredEvent.parameters.push(
    new ethereum.EventParam(
      "previousOwner",
      ethereum.Value.fromAddress(previousOwner)
    )
  )
  ownershipTransferredEvent.parameters.push(
    new ethereum.EventParam("newOwner", ethereum.Value.fromAddress(newOwner))
  )

  return ownershipTransferredEvent
}

export function createaddAllowedDonationTokenEventEvent(
  token: Address,
  timestamp: BigInt
): addAllowedDonationTokenEvent {
  let addAllowedDonationTokenEventEvent =
    changetype<addAllowedDonationTokenEvent>(newMockEvent())

  addAllowedDonationTokenEventEvent.parameters = new Array()

  addAllowedDonationTokenEventEvent.parameters.push(
    new ethereum.EventParam("token", ethereum.Value.fromAddress(token))
  )
  addAllowedDonationTokenEventEvent.parameters.push(
    new ethereum.EventParam(
      "timestamp",
      ethereum.Value.fromUnsignedBigInt(timestamp)
    )
  )

  return addAllowedDonationTokenEventEvent
}

export function createremoveAllowedDonationTokenEventEvent(
  token: Address,
  timestamp: BigInt
): removeAllowedDonationTokenEvent {
  let removeAllowedDonationTokenEventEvent =
    changetype<removeAllowedDonationTokenEvent>(newMockEvent())

  removeAllowedDonationTokenEventEvent.parameters = new Array()

  removeAllowedDonationTokenEventEvent.parameters.push(
    new ethereum.EventParam("token", ethereum.Value.fromAddress(token))
  )
  removeAllowedDonationTokenEventEvent.parameters.push(
    new ethereum.EventParam(
      "timestamp",
      ethereum.Value.fromUnsignedBigInt(timestamp)
    )
  )

  return removeAllowedDonationTokenEventEvent
}
