import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const REVIEW_PROMPT = `Review the code diff below. Focus on bugs, security, maintainability, and clarity. Be concise and prioritize actionable findings.`;

async function runGit(pi: ExtensionAPI, args: string[]): Promise<string> {
	const result = await pi.exec("git", args);
	return result.stdout;
}

export default function (pi: ExtensionAPI) {
	pi.registerCommand("minimal-review", {
		description: "Review code changes (uncommitted, staged, or against a branch)",
		handler: async (args, ctx) => {
			const { code } = await pi.exec("git", ["rev-parse", "--git-dir"]);
			if (code !== 0) {
				ctx.ui.notify("Not a git repository", "error");
				return;
			}

			let diff = "";
			const trimmed = args.trim();

			if (!trimmed || trimmed === "uncommitted") {
				diff = await runGit(pi, ["diff"]);
			} else if (trimmed === "staged") {
				diff = await runGit(pi, ["diff", "--staged"]);
			} else if (trimmed.startsWith("branch ")) {
				const branch = trimmed.slice(7).trim();
				const base = (await runGit(pi, ["merge-base", "HEAD", branch])).trim();
				diff = await runGit(pi, ["diff", base]);
			} else {
				ctx.ui.notify("Usage: /minimal-review [uncommitted|staged|branch <name>]", "error");
				return;
			}

			if (!diff.trim()) {
				ctx.ui.notify("No changes to review", "info");
				return;
			}

			pi.sendUserMessage(`${REVIEW_PROMPT}\n\n\`\`\`diff\n${diff}\n\`\`\``, { triggerTurn: true });
		},
	});
}
