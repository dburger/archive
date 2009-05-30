class Configuration {
  public:
    Configuration(int in_size);
    Configuration(Configuration *c);
    ~Configuration();
    void set_next(Configuration *c);
    Configuration *get_next();
    Configuration *get_parent();
    void print();
    void randomize();
    int get_blank_row();
    int get_blank_col();
    bool is_solved();
    int get_depth();
    void blank_left();
    void blank_right();
    void blank_up();
    void blank_down();
    enum elast_move { NONE, LEFT, RIGHT, UP, DOWN };
    int get_last_move();
  protected:
    int blank_pos;
    int size;
    int *grid;
    int depth;
    elast_move last_move;
    Configuration *next;
    Configuration *parent;
};

void print_path(Configuration *c);
