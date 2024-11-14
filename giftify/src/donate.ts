import {
  ClaimDonation as ClaimDonationEvent,
  Donation as DonationEvent,
  addAllowedDonationTokenEvent as addAllowedDonationTokenEventEvent,
  removeAllowedDonationTokenEvent as removeAllowedDonationTokenEventEvent
} from "../generated/Donate/Donate"
import {
  ClaimDonation,
  Donation,
  addAllowedDonationTokenEvent,
  removeAllowedDonationTokenEvent
} from "../generated/schema"

export function handleClaimDonation(event: ClaimDonationEvent): void {
  let entity = new ClaimDonation(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.donor = event.params.donor
  entity.amount = event.params.amount

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleDonation(event: DonationEvent): void {
  let entity = new Donation(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.donor = event.params.donor
  entity.amount = event.params.amount

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleaddAllowedDonationTokenEvent(
  event: addAllowedDonationTokenEventEvent
): void {
  let entity = new addAllowedDonationTokenEvent(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.token = event.params.token

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleremoveAllowedDonationTokenEvent(
  event: removeAllowedDonationTokenEventEvent
): void {
  let entity = new removeAllowedDonationTokenEvent(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.token = event.params.token

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}
