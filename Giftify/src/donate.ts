import {
  ClaimReward as ClaimRewardEvent,
  InitiateWithdraw as InitiateWithdrawEvent,
  NewDonation as NewDonationEvent,
  OwnershipTransferred as OwnershipTransferredEvent,
  addAllowedDonationTokenEvent as addAllowedDonationTokenEventEvent,
  removeAllowedDonationTokenEvent as removeAllowedDonationTokenEventEvent
} from "../generated/Donate/Donate"
import {
  ClaimReward,
  InitiateWithdraw,
  NewDonation,
  OwnershipTransferred,
  addAllowedDonationTokenEvent,
  removeAllowedDonationTokenEvent
} from "../generated/schema"

export function handleClaimReward(event: ClaimRewardEvent): void {
  let entity = new ClaimReward(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.user = event.params.user
  entity.amount = event.params.amount
  entity.timestamp = event.params.timestamp

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleInitiateWithdraw(event: InitiateWithdrawEvent): void {
  let entity = new InitiateWithdraw(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.creator = event.params.creator
  entity.shares = event.params.shares
  entity.timestamp = event.params.timestamp

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleNewDonation(event: NewDonationEvent): void {
  let entity = new NewDonation(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.gifter = event.params.gifter
  entity.grossAmount = event.params.grossAmount
  entity.netAmount = event.params.netAmount
  entity.creator = event.params.creator
  entity.gifterShares = event.params.gifterShares
  entity.timestamp = event.params.timestamp

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleOwnershipTransferred(
  event: OwnershipTransferredEvent
): void {
  let entity = new OwnershipTransferred(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.previousOwner = event.params.previousOwner
  entity.newOwner = event.params.newOwner

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
  entity.timestamp = event.params.timestamp

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
  entity.timestamp = event.params.timestamp

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}
