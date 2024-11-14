import { MerkleTree } from "merkletreejs";
import keccak256 from "keccak256";
import { solidityPackedKeccak256 } from "ethers";

const createMerkleTree = (claims: { address: string; amount: number }[]) => {
  const leaves = claims.map((claim) =>
    solidityPackedKeccak256(
      ["address", "uint256"],
      [claim.address, claim.amount]
    )
  );

  const merkleTree = new MerkleTree(leaves, keccak256, { sortPairs: true });
  const root = merkleTree.getHexRoot();
  return { merkleTree, leaves, root };
};

export { createMerkleTree };
