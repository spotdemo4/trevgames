<script lang="ts">
	// Settings
	let tickRate = 50;

	// State
	let snake: {
		x: number;
		y: number;
		direction: string;
		tail: { x: number; y: number }[];
	} = {
		x: 0,
		y: 0,
		direction: 'right',
		tail: []
	};
	let food: { x: number; y: number } | undefined;
	let isRunning = false;
	let interval: NodeJS.Timeout;
	let expandBy = 0;
	let gameWidth = 0;
	let gameHeight = 0;
	let bufferedDirection = 'right';
	let score = 0;

	function onKeyDown(e: KeyboardEvent) {
		if ((e.key === 'ArrowUp' || e.key === 'w') && snake.direction !== 'down') {
			bufferedDirection = 'up';
		} else if ((e.key === 'ArrowDown' || e.key === 's') && snake.direction !== 'up') {
			bufferedDirection = 'down';
		} else if ((e.key === 'ArrowLeft' || e.key === 'a') && snake.direction !== 'right') {
			bufferedDirection = 'left';
		} else if ((e.key === 'ArrowRight' || e.key === 'd') && snake.direction !== 'left') {
			bufferedDirection = 'right';
		} else if (e.key === ' ' || e.key === 'Enter') {
			if (isRunning) {
				clearInterval(interval);
				isRunning = false;
			} else {
				start();
			}
		}
	}

	function tick() {
		// Change snake direction
		snake.direction = bufferedDirection;

		// Expand snake tail
		if (expandBy > 0) {
			snake.tail.push({ x: snake.x, y: snake.y });
			expandBy--;
		}

		// Move snake tail
		snake.tail.pop();
		snake.tail.unshift({ x: snake.x, y: snake.y });
		snake.tail = snake.tail;

		// Move snake head
		if (snake.direction === 'up') {
			snake.y = snake.y - 20;
		} else if (snake.direction === 'down') {
			snake.y = snake.y + 20;
		} else if (snake.direction === 'left') {
			snake.x = snake.x - 20;
		} else if (snake.direction === 'right') {
			snake.x = snake.x + 20;
		}

		// Check for collision
		if (snake.x < 0) {
			reset();
		} else if (snake.x > gameWidth - 20) {
			reset();
		} else if (snake.y < 0) {
			reset();
		} else if (snake.y > gameHeight - 20) {
			reset();
		} else if (snake.tail.some((t) => t.x === snake.x && t.y === snake.y)) {
			reset();
		} else if (food && snake.x === food.x && snake.y === food.y) {
			expandBy += 3;
			score += 10;
			genFood();
		}
	}

	function reset() {
		snake.x = 0;
		snake.y = 0;
		snake.direction = 'right';
		bufferedDirection = 'right';
		snake.tail = [];
		food = undefined;
		clearInterval(interval);
		isRunning = false;
	}

	function start() {
		interval = setInterval(tick, tickRate);
		isRunning = true;
		if (!food) {
			score = 0;
			genFood();
		}
	}

	function genFood() {
		let x = Math.floor(Math.random() * ((gameWidth - 20) / 20)) * 20;
		let y = Math.floor(Math.random() * ((gameHeight - 20) / 20)) * 20;

		if (snake.tail.some((t) => t.x === x && t.y === y)) {
			genFood();
		} else {
			food = { x, y };
		}
	}
</script>

<div bind:offsetWidth={gameWidth} bind:offsetHeight={gameHeight} class="bg-slate-900 h-screen">
	{#if !isRunning}
		<div class="absolute inset-0 flex flex-col gap-2 items-center justify-center z-10">
			<div class="text-4xl font-bold text-white text-center">Snake</div>
			{#if food}
				<div class="text-xl text-white text-center">Score: {score}</div>
			{:else if score}
				<div class="text-4xl font-bold text-white text-center">Game Over</div>
				<div class="text-xl text-white text-center">Score: {score}</div>
			{/if}
			<button
				class="bg-green-500 text-white px-4 py-2 rounded"
				on:click={() => {
					start();
				}}
			>
				{#if food}
					Resume
				{:else if score}
					Restart
				{:else}
					Start
				{/if}
			</button>
		</div>
	{/if}
	<div id="snake" class="absolute w-5 h-5 bg-red-600" style="left: {snake.x}px; top: {snake.y}px" />
	{#each snake.tail as { x, y }}
		<div class="absolute w-5 h-5 bg-red-600" style="left: {x}px; top: {y}px" />
	{/each}
	{#if food}
		<div
			id="food"
			class="absolute w-5 h-5 bg-green-600"
			style="left: {food.x}px; top: {food.y}px"
		/>
	{/if}
	{#if score}
		<div class="absolute bottom-0 left-0 text-white">Score: {score}</div>
	{/if}
</div>

<svelte:window on:keydown|preventDefault={onKeyDown} />
