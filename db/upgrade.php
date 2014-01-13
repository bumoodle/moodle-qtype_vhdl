<?php
// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Essay question type upgrade code.
 *
 * @package    qtype
 * @subpackage essay
 * @copyright  2011 The Open University
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */


defined('MOODLE_INTERNAL') || die();


/**
 * Upgrade code for the essay question type.
 * @param int $oldversion the version we are upgrading from.
 */
function xmldb_qtype_vhdl_upgrade($oldversion) {
    global $CFG, $DB;

    $dbman = $DB->get_manager();

    if ($oldversion < 2013010301) {

        // Define field id to be added to question_vhdl_cache.
        $table = new xmldb_table('question_vhdl_cache');
        $field = new xmldb_field('raw_output', XMLDB_TYPE_TEXT, null, null, null, null, null, 'date');

        // Conditionally launch add field id.
        if (!$dbman->field_exists($table, $field)) {
            $dbman->add_field($table, $field);
        }

        // Vhdl savepoint reached.
        upgrade_plugin_savepoint(true, 2013010301, 'qtype', 'vhdl');
    }



    return true;
}

