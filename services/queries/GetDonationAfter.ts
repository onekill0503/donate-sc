import { gql } from 'graphql-request'

const GET_DONATION_AFTER = gql`
  query GetDonationsAfter($timestamp: BigInt!) {
    donations(where: { timestamp__gt: $timestamp }) {
      id
      block_number
      timestamp_
      transactionHash_
      contractId_
      donor
      amount
    }
  }
`;

export default GET_DONATION_AFTER;