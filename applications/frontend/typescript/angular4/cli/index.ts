

import chalk = require('chalk');
import inquirer = require('inquirer');
import fs = require('fs');
import { initializeScreen } from './lib/screen';
import { promptForChooseTemplate } from './lib/prompts';

initializeScreen();

promptForChooseTemplate().then((result) => {
    let template = result.template;
    fs.writeFileSync('/usr/src/app/.template', template);
});

