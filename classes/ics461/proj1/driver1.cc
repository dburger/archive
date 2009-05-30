#include <iostream>
#include <list>
#include <ctime>

#include "Configuration.h"

using namespace std;

#define GRID_SIZE 3

int main(int argc, char *argv[]) {
  list<Configuration> con_list;
  Configuration *head, *c = new Configuration(GRID_SIZE);
  srand(time(NULL));
  c->randomize();
  /* if solved stop here */
  con_list.push_back(*c);

  for (;;) {

    head = new Configuration(con_list.front());
    con_list.pop_front();

    cout << "Master:\n";
    head->print();

    if (head->get_blank_col() > 0) {
      c = new Configuration(head);
      c->set_parent(head);
      c->blank_left();
      cout << "Lefter:\n";
      c->print();
      if (c->is_solved()) break;
      con_list.push_back(*c);
      delete c;
    }

    if (head->get_blank_col() < GRID_SIZE - 1) {
      c = new Configuration(head);
      c->set_parent(head);
      c->blank_right();
      cout << "Righter:\n";
      c->print();
      if (c->is_solved()) break;
      con_list.push_back(*c);
      delete c;
    }

    if (head->get_blank_row() > 0) {
      c = new Configuration(head);
      c->set_parent(head);
      c->blank_up();
      cout << "Upper:\n";
      c->print();
      if (c->is_solved()) break;
      con_list.push_back(*c);
      delete c;
    }

    if (head->get_blank_row() < GRID_SIZE - 1) {
      c = new Configuration(head);
      c->set_parent(head);
      c->blank_down();
      cout << "Downer:\n";
      c->print();
      if (c->is_solved()) break;
      con_list.push_back(*c);
      delete c;
    }


  }

  cout << "Problem solved\n";
  print_path(c);

}
