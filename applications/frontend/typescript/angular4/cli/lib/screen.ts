import figlet = require('figlet');
import chalk = require('chalk');
import clear = require('clear');

export function initializeScreen() {
    clear();
    console.log(
        chalk.yellow(
            figlet.textSync('Angular 4 Dockerized', { horizontalLayout: 'full' })
        )
    );

}