#include <iostream>
#include <ctime>

#include "Configuration.h"

using namespace std;

#define GRID_SIZE 3
#define MAX_DEPTH 20

int main(int argc, char *argv[]) {
  Configuration *c, *head, *tail;
  srand(time(NULL));
  head = tail = c = new Configuration(GRID_SIZE);
  c->randomize();

  if (!c->is_solved()) {

    while (head != NULL && head->get_depth() < MAX_DEPTH) {

      cout << "Head:\n" << head->get_depth() << "\n";
      head->print();

      /* left move */
      if (head->get_last_move() != Configuration::RIGHT &&
          head->get_blank_col() > 0) {
	c = new Configuration(head);
	c->blank_left();
	if (c->is_solved()) break;
	tail->set_next(c);
	tail = c;
      }

      /* right move */
      if (head->get_last_move() != Configuration::LEFT &&
          head->get_blank_col() < GRID_SIZE - 1) {
	c = new Configuration(head);
	c->blank_right();
	if (c->is_solved()) break;
	tail->set_next(c);
	tail = c;
      }

      /* up move */
      if (head->get_last_move() != Configuration::DOWN &&
          head->get_blank_row() > 0) {
	c = new Configuration(head);
	c->blank_up();
	if (c->is_solved()) break;
	tail->set_next(c);
	tail = c;
      }

      /* down move */
      if (head->get_last_move() != Configuration::UP &&
          head->get_blank_row() < GRID_SIZE - 1) {
	c = new Configuration(head);
	c->blank_down();
	if (c->is_solved()) break;
	tail->set_next(c);
	tail = c;
      }

      head = head->get_next();

    }

  }

  if (c->is_solved()) {
    cout << "Problem solved\n";
    print_path(c);
  } else {
    cout << "Problem not solved\n";
  }

}
