import com.ibm.rally.Car;
import com.ibm.rally.ICar;
import com.ibm.rally.IObject;

import java.util.Random;

/**
 * This is the class that you must implement to enable your car within
 * the CodeRally track. Adding code to these methods will give your car
 * it's personality and allow it to compete.
 */
public class RallyCar extends Car {
	
  /** State machine state for running the checkpoints. */
	private static final int SCORE_POINTS_STATE = 0;
  
  /** State machine state for gassing up. */
	private static final int GAS_UP_STATE = 1;
  
  /** State machine state for collision recovery. */
	private static final int COLLISION_RECOVERY_STATE = 2;

  /** The throttle setting for normal driving. */
  private static final int CRUISING_SPEED = Car.MAX_THROTTLE;
  
  /** The throttle setting for reverse driving. */
  private static final int REVERSE_SPEED = Car.MIN_THROTTLE;
  
  /** Level to drop to before changing to GAS_UP_STATE. */
  private static final int REFUEL_FUEL_LEVEL = 35;
  
  /** Level to fill to before returning to SCORE_POINTS_STATE. */
  private static final int RESUME_FUEL_LEVEL = 85;
  
  /** Amount of time to go in reverse after a collision. */
  private static final int DEFAULT_COLLISION_WAIT = 8;
  
  /**
   * Amount of distance from a fuel depot beyond which we will randomly pick a fuel depot
   * if a collision occurs on the way to the fuel depot.
   */
  private static final int FUEL_RANDOM_DISTANCE = 30;
  
  /** Time at which we abandon refueling at proceed with checkpointing. */
  private static final int STOP_FUELING_TIME = 80;
	
  /** Holds the current state. */
  private int state;
  
  /** Index of next checkpoint in checkpoint loop. */
	private int nextCheckpoint;
  
  /** The fuel depot to go to for filling up. */
  private int targetFuelDepot;
  
  /** Amount of time left to wait after a collision */
  private int collisionWait;
  
  /** Random number generator. */
  private Random generator = null;
	
	/**
	 * @see com.ibm.rally.Car#getName()
	 */
	public String getName() {
		return "Christine";
	}

	/**
	 * @see com.ibm.rally.Car#getSchoolName()
	 */
	public String getSchoolName() {
		return "School of Hard Knocks";
	}

	/**
	 * @see com.ibm.rally.Car#getColor()
	 */
	public byte getColor() {
		return RallyCar.CAR_PURPLE;
	}

	/**
	 * @see com.ibm.rally.Car#initialize()
	 */
	public void initialize() {
    this.nextCheckpoint = getClosestObjectIndex(getCheckpoints());
    this.generator = new Random();
		this.state = RallyCar.SCORE_POINTS_STATE;
		setThrottle(RallyCar.CRUISING_SPEED);
	}

	/**
	 * @see com.ibm.rally.Car#move(int, boolean, ICar, ICar)
	 */
	public void move(int lastMoveTime, boolean hitWall, ICar collidedWithCar, ICar hitBySpareTire) {
		if (collidedWithCar != null) {
      throwSpareTire();
      setThrottle(RallyCar.REVERSE_SPEED);
      this.collisionWait = RallyCar.DEFAULT_COLLISION_WAIT;
      // hopefully avoid re-colliding
      this.nextCheckpoint = this.generator.nextInt(getCheckpoints().length);
      if (getFuel() > RallyCar.FUEL_RANDOM_DISTANCE) {
        this.targetFuelDepot = this.generator.nextInt(getFuelDepots().length);
      }
      this.state= RallyCar.COLLISION_RECOVERY_STATE;      
		}
		switch (this.state) {
			case RallyCar.SCORE_POINTS_STATE:
        // to get back up to speed if hit by a tire
        setThrottle(RallyCar.CRUISING_SPEED);
			  if (getPreviousCheckpoint() == this.nextCheckpoint) {
			  	this.nextCheckpoint = ++this.nextCheckpoint % getCheckpoints().length;
			  }
			  int destHeading = getHeadingTo(getCheckpoints()[this.nextCheckpoint]);
				setSteeringSetting(getSteeringSettingTo(destHeading));
        if (getFuel() < RallyCar.REFUEL_FUEL_LEVEL
            && getClockTicks() > RallyCar.STOP_FUELING_TIME) {
          this.targetFuelDepot = getClosestObjectIndex(getFuelDepots());
          this.state = RallyCar.GAS_UP_STATE;
        }
			  break;
			case RallyCar.GAS_UP_STATE:
			  destHeading = getHeadingTo(getFuelDepots()[this.targetFuelDepot]);
			  setSteeringSetting(getSteeringSettingTo(destHeading));
			  double distToFuel = getDistanceTo(getFuelDepots()[this.targetFuelDepot]);
			  int throttleSetting = (distToFuel < 25) ? 0 : (int)distToFuel / 2; 
			  setThrottle(throttleSetting);
			  if (getFuel() > RallyCar.RESUME_FUEL_LEVEL
            || getClockTicks() < RallyCar.STOP_FUELING_TIME) {
          this.nextCheckpoint = getClosestObjectIndex(getCheckpoints());
			  	setThrottle(RallyCar.CRUISING_SPEED);
			  	this.state = RallyCar.SCORE_POINTS_STATE;
			  }
			  break;
			case RallyCar.COLLISION_RECOVERY_STATE:
        if (this.collisionWait <= 0) {
          setThrottle(RallyCar.CRUISING_SPEED);
          this.state = RallyCar.SCORE_POINTS_STATE; 
        } else {
          this.collisionWait--;
        }
			  break;
			default:
			  System.out.println("err");
  		}
	}
	
	/**
	 * Returns the steering setting that should be used to get this
	 * <code>RallyCar</code> to head in direction <code>destHeading</code>.
	 * 
	 * @param destHeading
	 * @return steering setting to head in direction <code>destHeading</code>
	 */
	private int getSteeringSettingTo(int destHeading) {
		int myHeading = getHeading();
		int diffHeading = destHeading - myHeading;
		int steeringSetting = 0;
		if (diffHeading > -360 && diffHeading <= -180) {
			steeringSetting = Car.MAX_STEER_RIGHT;
		}
		else if (diffHeading > -180 && diffHeading <= 0) {
			steeringSetting = Math.max(diffHeading, Car.MAX_STEER_LEFT);
		}
		else if (diffHeading > 0 && diffHeading <= 180) {
			steeringSetting = Math.min(diffHeading, Car.MAX_STEER_RIGHT);
		}
		else if (diffHeading > 180 && diffHeading <= 360) {
			steeringSetting = Car.MAX_STEER_LEFT;
		}
		return steeringSetting;
	}
  
  /**
   * Returns the index of the closest <code>IObject</code> in <code>objects</code>.
   * 
   * @param objects array of <code>IObject</code>s to look through for closes
   * @return the index of the closest <code>IObject</code>
   */
  private int getClosestObjectIndex(IObject[] objects) {
    double minDistance = Double.MAX_VALUE;
    int closestIndex = 0;
    for (int i = 0; i < objects.length; i++) {
      double distance = getDistanceTo(objects[i]);
      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }
    return closestIndex;
  }
  
}