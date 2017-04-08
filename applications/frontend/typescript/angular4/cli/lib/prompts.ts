
import inquirer = require('inquirer');
import chalk = require('chalk');

export const selectTemplateQuestion: inquirer.Question = {
    name: "template",
    type: "list",

    message: chalk.green("Qual template de Aplicação Angular 4 você deseja carregar?"),
    choices: [
        { name: 'Angular 4 com Jest', value: 'angular@4.0.1-jest' },
        { name: 'Angular 4 com Karma e PhantomJS', value: 'angular@4.0.1' }
    ],
    default: 'angular@4.0.1-jest'
};

export function promptForChooseTemplate() {
    return inquirer.prompt(selectTemplateQuestion);
}