import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-ethers";

require("dotenv").config({ path: __dirname + "/.env" });

const config: HardhatUserConfig = {
    solidity: "0.8.17",
    networks: {
        mumbai: {
            url: process.env.MUMBAI_ALCHEMY_URL || "",
            accounts: [`0x${process.env.SIGNER_WALLET}`],
        },
    },
};

export default config;
