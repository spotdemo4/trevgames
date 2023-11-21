import type { PageServerLoad } from './$types';
import { readFileSync } from 'fs';

export const load: PageServerLoad = async ({ params }) => {
    const file = readFileSync('./static/wordlist.txt', 'utf-8');
    let dictionary = file.toString().split(/\r?\n/);
    return { dictionary: dictionary };
}