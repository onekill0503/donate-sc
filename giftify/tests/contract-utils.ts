import { newMockEvent } from "matchstick-as"
import { ethereum, Address, BigInt } from "@graphprotocol/graph-ts"
import {
  ClaimDonation,
  Donation,
  addAllowedDonationTokenEvent,
  removeAllowedDonationTokenEvent
} from "../generated/Contract/Contract"

export function createClaimDonationEvent(
  donor: Address,
  amount: BigInt
): ClaimDonation {
  let claimDonationEvent = changetype<ClaimDonation>(newMockEvent())

  claimDonationEvent.parameters = new Array()

  claimDonationEvent.parameters.push(
    new ethereum.EventParam("donor", ethereum.Value.fromAddress(donor))
  )
  claimDonationEvent.parameters.push(
    new ethereum.EventParam("amount", ethereum.Value.fromUnsignedBigInt(amount))
  )

  return claimDonationEvent
}

export function createDonationEvent(donor: Address, amount: BigInt): Donation {
  let donationEvent = changetype<Donation>(newMockEvent())

  donationEvent.parameters = new Array()

  donationEvent.parameters.push(
    new ethereum.EventParam("donor", ethereum.Value.fromAddress(donor))
  )
  donationEvent.parameters.push(
    new ethereum.EventParam("amount", ethereum.Value.fromUnsignedBigInt(amount))
  )

  return donationEvent
}

export function createaddAllowedDonationTokenEventEvent(
  token: Address
): addAllowedDonationTokenEvent {
  let addAllowedDonationTokenEventEvent =
    changetype<addAllowedDonationTokenEvent>(newMockEvent())

  addAllowedDonationTokenEventEvent.parameters = new Array()

  addAllowedDonationTokenEventEvent.parameters.push(
    new ethereum.EventParam("token", ethereum.Value.fromAddress(token))
  )

  return addAllowedDonationTokenEventEvent
}

export function createremoveAllowedDonationTokenEventEvent(
  token: Address
): removeAllowedDonationTokenEvent {
  let removeAllowedDonationTokenEventEvent =
    changetype<removeAllowedDonationTokenEvent>(newMockEvent())

  removeAllowedDonationTokenEventEvent.parameters = new Array()

  removeAllowedDonationTokenEventEvent.parameters.push(
    new ethereum.EventParam("token", ethereum.Value.fromAddress(token))
  )

  return removeAllowedDonationTokenEventEvent
}
