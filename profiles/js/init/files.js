const fs = require('fs')
const path = require('path')

const exists = (filepath) => {
  try {
    fs.statSync(filepath);
    return true
  } catch (err) {
    return false;
  }
}

const readFile = (filepath) => {
  if(!exists(filepath)) {
    console.error(`file doesn't exist @ ${filepath}`)
    return [];
  }

  return fs.readFileSync(filepath)
    .toString('UTF-8')
    .split('\n');
}

const readJson = (filePath) => {
  const contents = readFile(filePath);

  if(!contents) {
    return [];
  }

  return JSON.parse(contents.join('\n'));
}

const writeFile  = (filepath, contents) => {
  try {
    fs.writeFileSync(filepath, contents.join('\n').concat(['\n']));   // concat here to ensure you get a newline at EOF
  } catch(err) {
    console.error(`error (probably nonexistent dir path) @ ${filepath}`)
    throw err;
  }
}

const writeJson = (filepath, obj) => {
  try {
    fs.writeFileSync(filepath, JSON.stringify(obj));
  } catch(err) {
    console.error(`error (probably nonexistent dir path) @ ${filepath}`)
    throw err;
  }
}

const appendFile  = (filepath, contents) => {
  try {
    fs.appendFileSync(filepath, contents.join('\n').concat(['\n']));   // concat here to ensure you get a newline at EOF
  } catch(err) {
    console.error(`error (probably nonexistent dir path) @ ${filepath}`)
    throw err;
  }
}

const appendJson = (filepath, obj) => {
  try {
    fs.appendFileSync(filepath, JSON.stringify(obj));
  } catch(err) {
    console.error(`error (probably nonexistent dir path) @ ${filepath}`)
    throw err;
  }
}

// TODO: cil.yargs -- get argv outta here

function outFile(argv, contents, defaultPath) {
  const writePath = (!!argv.out) ? argv.out : (!!argv.o) ? argv.o : defaultPath;  // could trim '.xf' here, but seems good for now, keep it light
  if(!(!!writePath)) {
    return false;
  }

  files.writeFile(writePath, contents);
  return true;
}

function outJson(argv, obj, defaultPath) {
  const writePath = (!!argv.out) ? argv.out : (!!argv.o) ? argv.o : defaultPath;  // could trim '.xf' here, but seems good for now, keep it light
  if(!(!!writePath)) {
    return false;
  }

  files.writeJson(writePath, obj);
  return true;
}

// NOTE: should probably support search strings or w/e
// probably even a built-in way to do that i bet
const getFiles = (dir) => fs.readdirSync(dir).filter(file => path.extname(file).toLowerCase() === '.xf');

const mkdir = (dir) => {
  if(!exists(dir)) {
    fs.mkdirSync(dir);
  }
}

function delete_file(path) {
  if(!exists(path)) {
    return true
  }

  try {
    fs.unlinkSync(path)
    return true
  } catch(error) {
    return false
  }
}
exports.delete_file = delete_file

const files = {
  exists: exists,
  readFile: readFile,
  writeFile: writeFile,
  appendFile: appendFile,
  getFiles: getFiles,

  readJson: readJson,
  writeJson: writeJson,
  appendJson: appendJson,

  outFile: outFile,
  outJson: outJson,

  mkdir: mkdir,

  delete_file: delete_file,
}

exports.files = files;
