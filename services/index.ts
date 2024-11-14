import { GraphQLClient } from "graphql-request";
import type Donation from "./types/Donation.schema";
import GET_DONATION_AFTER from "./queries/GetDonationAfter";

const endpoint = process.env.SUBGRAPH_ENDPOINT ?? ``;

const client = new GraphQLClient(endpoint);

(async () => {
    try {
        const response = await client.request<{ donations: Donation[] }>(GET_DONATION_AFTER , {timestamp: '1731574705'});
        console.log(response.donations)
        return response;
      } catch (error) {
        console.error("Error fetching donations:", error);
        throw error;
      }
})()