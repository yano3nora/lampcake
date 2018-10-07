<?php 
namespace App\Shell;

use Cake\Console\Shell;
use Cake\Datasource\ConnectionManager;

/**
 * DropShell Class.
 * Drop all application tables for development. 
 *
 * @access public
 * @author hyano@ampware.jp
 * @category Batch processing
 * @package Shell
 */
class DropShell extends Shell
{

  
  /** 
   * Initialize instance for all methods.
   * @param  void
   * @return void
   */
  public function initialize() {
    parent::initialize();
    $this->Connection = ConnectionManager::get('default');
  }

  
  /**
   * Printing welcome messages.
   * @param  void
   * @return void
   */
  public function startup() {
    // If you want to output welcome messages, override parent method like this.
    // parent::startup();
  }


  /**
   * Option Parser.
   * @param  void
   * @return OptionParser
   */
  public function getOptionParser() {
    $parser = parent::getOptionParser();
    $parser->addOption('force', [
      'help'    => 'Skip interaction.',
      'short'   => 'f',
      'boolean' => true,
    ]);
    return $parser;
  }

  
  /** 
   * Main command for `bin/cake drop`.
   * Method runs when executed without sub-command or args.
   * @param  void
   * @return void
   */
  public function main() {
    if (!$this->params['force']) {
      $isContinue = $this->in('Want to continue the process ?', ['y', 'N'], 'N');
      if ($isContinue !== 'y') $this->abort('Process was canceled.');
    }
    if (empty($this->Connection)) $this->abort('Fatal: Missing DB connection.');
    $tables = $this->Connection->schemaCollection()->listTables();
    if (!empty($tables)) {
      $tables = implode(', ', $tables);
      $this->connection->query('SET FOREIGN_KEY_CHECKS=0');
      $this->connection->query('DROP TABLE '.$tables);
      $this->connection->query('SET FOREIGN_KEY_CHECKS=1');
    }
    $this->out('success!');
  }


}