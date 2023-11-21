<script lang="ts">
	import type { PageData } from './$types';

	export let data: PageData;
	shuffleArray(data.dictionary);
	let current_index = 0;
	let score = 0;
	let input_value = '';
	let progress = 100;
	let interval: NodeJS.Timeout;
	let intervalRunning = false;
	let game_over = false;

	function shuffleArray(array: string[]) {
		for (let i = array.length - 1; i > 0; i--) {
			const j = Math.floor(Math.random() * (i + 1));
			[array[i], array[j]] = [array[j], array[i]];
		}
	}

	function decrement() {
		if (progress <= 0) {
			clearInterval(interval);
			intervalRunning = false;
			game_over = true;
		}
		progress = progress - (1 + score / 50);
	}
</script>

<div class="bg-slate-900 h-screen flex flex-col gap-2 justify-center items-center">
	{#if game_over}
        <div class="text-white font-bold text-4xl">
            Game Over
        </div>
        <div class="text-white text-2xl">
            Score: {score}
        </div>
        <button
            class="text-white bg-green-800 rounded-xl p-2"
            on:click={() => {
                shuffleArray(data.dictionary);
                current_index = 0;
                score = 0;
                input_value = '';
                progress = 100;
                game_over = false;
            }}
        > Play Again </button>
    {:else}
		<progress class="w-1/2 mb-10 rounded bg-gray-800" value={progress} max={100}></progress>
		{#if data.dictionary[current_index - 1]}
			<div class="text-green-700 text-1xl">
				{data.dictionary[current_index - 1].toUpperCase()}
			</div>
		{/if}
		<div class="text-white font-bold text-4xl">
			{data.dictionary[current_index].toUpperCase()}
		</div>
		<div class="text-slate-400 text-3xl">
			{data.dictionary[current_index + 1].toUpperCase()}
		</div>
		<div class="text-slate-400 text-2xl">
			{data.dictionary[current_index + 2].toUpperCase()}
		</div>
		<div class="text-slate-400 text-xl">
			{data.dictionary[current_index + 3].toUpperCase()}
		</div>
		<div class="text-slate-400 text-md">
			{data.dictionary[current_index + 4].toUpperCase()}
		</div>
		<div class="text-slate-400 text-sm">
			{data.dictionary[current_index + 5].toUpperCase()}
		</div>
		<input
			class="text-white bg-gray-800 mt-10 rounded-xl p-2 text-2xl w-1/2 text-center focus:outline-none focus:ring-2 focus:ring-green-500"
			type="text"
			placeholder={data.dictionary[current_index].toUpperCase()}
			bind:value={input_value}
			on:input={() => {
				if (!intervalRunning) {
					intervalRunning = true;
					interval = setInterval(decrement, 50);
				}
				if (data.dictionary[current_index].toLowerCase() === input_value.toLowerCase()) {
					current_index = current_index + 1;
					score = score + 1;
					input_value = '';
					progress = 100;
				}
			}}
		/>
		<div class="text-white">Score: {score}</div>
	{/if}
</div>
