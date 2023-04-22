import { writeFileSync, readFileSync, existsSync } from "fs";
import { ArgumentParser } from "argparse";
import { fetch } from "undici";

interface Follower {
  id: string;
  name: string;
  username: string;
}

interface CURLResponse {
  meta: { result_count: number };
  data: Follower[];
}

const parser = new ArgumentParser({ description: "Followers Observer" });

parser.add_argument("-u", "--user-id", { help: "User ID", required: true });
parser.add_argument("-t", "--bearer-token", {
  help: "Bearer Token",
  required: true,
});

const args = parser.parse_args();
const USER_ID = args.user_id;
const BEARER_TOKEN = args.bearer_token;

const fetchFollowers = async (userId: string, bearerToken: string) => {
  const url = `https://api.twitter.com/2/users/${userId}/followers?max_results=1000`;
  const init = { headers: { Authorization: `Bearer ${bearerToken}` } };
  const response = await fetch(url, init);
  if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
  const data = (await response.json()) as CURLResponse;
  return data;
};

const compareFollowers = (
  oldFollowers: Follower[],
  newFollowers: Follower[]
) => {
  const oldMap = oldFollowers.reduce((b, a) => (b.set(a.id, a), b), new Map());
  const newMap = newFollowers.reduce((b, a) => (b.set(a.id, a), b), new Map());
  const addedFollowers = newFollowers.filter(
    (follower) => !oldMap.has(follower.id)
  );
  const removedFollowers = oldFollowers.filter(
    (follower) => !newMap.has(follower.id)
  );

  return { addedFollowers, removedFollowers };
};

const styledOutputWithLink = (follower: Follower) => {
  console.log(
    `  - \x1b[35m${follower.name}\x1b[36m@${follower.username}\x1b[0m (https://twitter.com/i/user/${follower.id})`
  );
};

const printFollowers = (label: string, followers: Follower[]) => {
  console.log(`\x1b[33m${label}\x1b[0m`);
  if (followers.length === 0) {
    console.log("  No changes");
  } else {
    followers.forEach(styledOutputWithLink);
  }
};

(async () => {
  try {
    const newFollowersData = await fetchFollowers(USER_ID, BEARER_TOKEN);
    if (!existsSync("followers.old.json")) {
      writeFileSync("followers.old.json", JSON.stringify(newFollowersData));
      console.log("No previous data found, creating a new one.");
      return;
    }
    const oldFollowersData: CURLResponse = JSON.parse(
      readFileSync("followers.old.json", "utf8")
    );
    const { addedFollowers, removedFollowers } = compareFollowers(
      oldFollowersData.data,
      newFollowersData.data
    );
    printFollowers("Added followers:", addedFollowers);
    printFollowers("Removed followers:", removedFollowers);
    writeFileSync("followers.old.json", JSON.stringify(newFollowersData));
  } catch (error) {
    console.error("An error occurred:\n", error);
  }
})();
