import { gql } from 'graphql-request'

const GET_ALL_DONATION = gql`
query getLatestDonation {
  donations {
    id,block_number,timestamp_,transactionHash_,contractId_,donor,amount
  }
}
`;

export default GET_ALL_DONATION;