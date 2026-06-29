import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const REVIEW_PROMPT = `Review the code diff below. Focus on bugs, security, maintainability, and clarity. Be concise and prioritize actionable findings.`;

const PR_REVIEW_PROMPT = `Review the pull request diff below. Focus on bugs, security, maintainability, clarity, and whether the changes correctly address the PR's intent. Be concise and prioritize actionable findings.`;

async function runGit(pi: ExtensionAPI, args: string[]): Promise<string> {
	const result = await pi.exec("git", args);
	return result.stdout;
}

function parsePrNumber(input: string): number | null {
	const num = parseInt(input, 10);
	if (!isNaN(num) && num > 0) return num;

	const urlMatch = input.match(/github\.com\/[^/]+\/[^/]+\/pull\/(\d+)/);
	if (urlMatch) return parseInt(urlMatch[1], 10);

	return null;
}

export default function (pi: ExtensionAPI) {
	pi.registerCommand("minimal-review", {
		description: "Review code changes (uncommitted, staged, branch, or PR)",
		handler: async (args, ctx) => {
			const { code } = await pi.exec("git", ["rev-parse", "--git-dir"]);
			if (code !== 0) {
				ctx.ui.notify("Not a git repository", "error");
				return;
			}

			let diff = "";
			let prompt = REVIEW_PROMPT;
			const trimmed = args.trim();

			if (!trimmed || trimmed === "uncommitted") {
				diff = await runGit(pi, ["diff"]);
			} else if (trimmed === "staged") {
				diff = await runGit(pi, ["diff", "--staged"]);
			} else if (trimmed.startsWith("branch ")) {
				const branch = trimmed.slice(7).trim();
				const base = (await runGit(pi, ["merge-base", "HEAD", branch])).trim();
				diff = await runGit(pi, ["diff", base]);
			} else if (trimmed.startsWith("pr ")) {
				const prInput = trimmed.slice(3).trim();
				const prNumber = parsePrNumber(prInput);
				if (!prNumber) {
					ctx.ui.notify("Usage: /minimal-review pr <number|url>", "error");
					return;
				}

				const { stdout, stderr, code: ghCode } = await pi.exec("gh", [
					"pr",
					"diff",
					String(prNumber),
				]);
				if (ghCode !== 0) {
					ctx.ui.notify(
						`Could not get diff for PR #${prNumber}. Make sure gh is installed, authenticated, and the PR exists. ${stderr || stdout}`,
						"error",
					);
					return;
				}

				diff = stdout;
				prompt = PR_REVIEW_PROMPT;
			} else {
				ctx.ui.notify(
					"Usage: /minimal-review [uncommitted|staged|branch <name>|pr <number|url>]",
					"error",
				);
				return;
			}

			if (!diff.trim()) {
				ctx.ui.notify("No changes to review", "info");
				return;
			}

			pi.sendUserMessage(`${prompt}\n\n\`\`\`diff\n${diff}\n\`\`\``, { triggerTurn: true });
		},
	});
}
